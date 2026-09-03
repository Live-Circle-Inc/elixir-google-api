# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule GoogleApis.DiscoveryTest do
  use ExUnit.Case
  doctest GoogleApis.Discovery
  alias GoogleApis.Discovery

  @moduletag :external

  test "fetch GOOGLE_REST_SIMPLE_URI urls" do
    assert {:ok, {body, format}} =
             Discovery.fetch("https://pubsub.googleapis.com/$discovery/rest?version=v1")

    assert "GOOGLE_REST_SIMPLE_URI" == format

    assert {:ok, content} = Poison.decode(body)
    assert "Pubsub" == content["canonicalName"]
  end

  # Exercises the try_formats/3 fallback: GOOGLE_REST_SIMPLE_URI 404s for this
  # API, so fetch/1 must retry with the original "rest" format.
  #
  # Previously pointed at analyticsreporting v4, whose discovery document now
  # 404s in both formats (Google retired the API), making this assert the
  # impossible. BigQuery v2 is a long-lived API that still behaves this way.
  test "fetch fallback rest urls" do
    assert {:ok, {body, format}} =
             Discovery.fetch(
               "https://bigquery.googleapis.com/$discovery/rest?version=v2"
             )

    assert "rest" == format

    assert {:ok, content} = Poison.decode(body)
    assert "Bigquery" == content["canonicalName"]
  end

  test "fetch default urls" do
    assert {:ok, {body, format}} =
             Discovery.fetch(
               "https://www.googleapis.com/discovery/v1/apis/compute/v1/rest"
             )

    assert "default" == format

    assert {:ok, content} = Poison.decode(body)
    assert "compute:v1" == content["id"]
  end
end
